From: Lars Wirzenius <liw@liw.fi>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Fri, 11 Feb 2011 12:41:08 +0000
Message-ID: <1297428068.3105.50.camel@havelock.lan>
References: <1297081322.4615.10.camel@monotop> <4D53C711.3000309@nsc.liu.se>
	 <AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>
	 <ij0iku$hbq$1@dough.gmane.org>
	 <AANLkTi=7B1FLtSrcJ88zgitCBiRctwveRhLzt_2yAHZL@mail.gmail.com>
	 <1297344585.28159.12.camel@monotop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Eduardo Silva <eduardo.silva@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297344585.28159.12.camel@monotop>
List-ID: <linux-btrfs.vger.kernel.org>

On to, 2011-02-10 at 10:29 -0300, Eduardo Silva wrote:
> [PATCH] Add safe string manipulation functions
> 
> Deprecate direct use of strcpy(3)
> The following string manipulation function has been added:
> 
>    - string_copy() : wrapper of strcpy(3)
>    - string_ncopy(): wrapper of strncpy(3)
> 
> both function compose safe NULL terminated strings.

I'd like make some comments, which I hope will be acceptable.

Firstly, calling strcpy dangerous is, to me, rather overblown. It is
easy to make mistakes, but it is not at all dangerous the way, for
example, gets(3) is dangerous. strcpy can be used safely, gets cannot.
Also, if you consider strcpy to be dangerous, then strcat should be
dangerous too. However, given the risk of overwriting a buffer with
strcpy, I agree that it's good to see if an alternative can be found.

Secondly, if you're going to make wrappers or helper functions for
string handling in C, you need to decide several things right from the
start:

* do you do static or dynamic allocation?
* how do you handle errors?
* do you want a minimal wrapper or replacement, or a whole new library?

I am not familiar enough with the btrfs-progs code base to give any
strong recommendations, but off the top of my head I would suggest
these, for this patch:

* make use of fairly minimal wrappers/replacements (at least for now)
* handle errors by calling abort or exit
* don't allocate data dynamically (or else it's not a minimal wrapper)

For error handling, there are two kinds of things that can happen:
normal run-time errors (malloc returns NULL, writing to a file fails,
etc), and programming errors (wrong parameters to functions). If we're
doing a minimal wrapper without dynamic memory allocation, the only
thing string functions should need to worry about is programming errors.
For those, abort(3) is the appropriate way to terminate the program,
since it causes a core dump, which can be inspected with a debugger.
Since btrfs-progs are non-interactive command line tools, this should be
OK.

For checking function arguments, the assert macro is appropriate. It
calls abort if the test fails. I am not sure I would check for
parameters being non-NULL, though, since the kernel will trap such usage
and cause a segfault, which, again, can be analyzed with a debugger.

For things like string copying, another problem to consider is what to
do if the target array is not large enough? The two possibilities is to
silently truncate the output string, return an error code of some sort,
or to abort. The error code is a bit tedious, since it requires the
caller to check for it, and do something sensible if it's not enough.
For btrfs-progs, I would suggest aborting.

Taking all of these together, my suggestion for a "safer strcpy" would
be along these lines (outline only, not tested code):

        void safer_strcpy(char *target, size_t tsize, const char
        *source)
        {
            size_t n;
        
            n = snprintf(target, tsize, "%s", source);
            assert(n < tsize);
        }
        
        void safer_strncpy(char *tgt, size_t tsize, const char *src, size_t n)
        {
            assert(n < tsize); /* There must be space for the '\0'. */
            memset(tgt, '\0', tsize);
            strncpy(tgt, src, n);
        }

Note that for any reasonable error checking to be possible the safety
functions need to know the size of the target memory area. Otherwise no
sensible checks can be done -- you have to rely on the caller to check
that the target array is big enough, and then you're nowhere better than
with plain strcpy.

(Also note that I did not call the function string_copy, since global
names starting with str are reserved to the C implementation.)

Your function fills in the target array with zero bytes. Is that
necessary? If it is, then the memset call needs to be added to
safer_strcpy.

(I don't find it useful to return the target array as the return value
of the function, so I didn't do that.)

-- 
Blog/wiki/website hosting with ikiwiki (free for free software):
http://www.branchable.com/

