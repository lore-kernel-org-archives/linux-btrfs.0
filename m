From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: [PATCH] Btrfs-progs use safe string manipulation functions
Date: Thu, 10 Feb 2011 19:39:46 +0100
Message-ID: <4D5430F2.700@libero.it>
References: <1297081322.4615.10.camel@monotop> <4D53C711.3000309@nsc.liu.se>	 <AANLkTi=OaU8Wj+W2KuPZLbq_85_yVK9mTer9Q7hfTCUc@mail.gmail.com>	 <ij0iku$hbq$1@dough.gmane.org>	 <AANLkTi=7B1FLtSrcJ88zgitCBiRctwveRhLzt_2yAHZL@mail.gmail.com> <1297344585.28159.12.camel@monotop>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Olaf van der Spek <olafvdspek@gmail.com>,
	Jeremy Sanders <jeremy@jeremysanders.net>,
	linux-btrfs@vger.kernel.org
To: Eduardo Silva <eduardo.silva@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1297344585.28159.12.camel@monotop>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/10/2011 02:29 PM, Eduardo Silva wrote:
> On Thu, 2011-02-10 at 12:39 +0100, Olaf van der Spek wrote:
>> On Thu, Feb 10, 2011 at 12:37 PM, Jeremy Sanders
>> <jeremy@jeremysanders.net> wrote:
>>> Olaf van der Spek wrote:
>>>
>>>> On Thu, Feb 10, 2011 at 12:08 PM, Thomas Bellman <bellman@nsc.liu.se>
>>>> wrote:
>>>>> strncpy(args.name, source, BTRFS_PATH_NAME_MAX);
>>>>> args.name[BTRFS_PATH_NAME_MAX] = '\0';
>>>>
>>>> That's silly. Isn't there a sane safe variant of strcpy?
>>>
>>> There's strlcpy, but it's not in glibc because of possible truncation
>>> errors!
>>
>> Then use a private wrapper.
>>
> 
> Here's the new patch:
> 
> ----
> [PATCH] Add safe string manipulation functions
> 
> Deprecate direct use of strcpy(3)
> The following string manipulation function has been added:
> 
>    - string_copy() : wrapper of strcpy(3)
>    - string_ncopy(): wrapper of strncpy(3)
> 
> both function compose safe NULL terminated strings.
> ----
> 
> I check that the code most of the time raise an error if the path is too
> long, so the new wrappers should be ok...
> 
> best, 
> 
> Eduardo Silva
>  
[...]
+char *string_copy(char *dest, const char *src)
+{
+	if (!dest || !src) {
+		fprintf(stderr, "ERROR: invalid string_copy() parameters");
+		exit(EXIT_FAILURE);
+	}
+
+	memset(dest, '\0', sizeof(dest));

What is the purpose of the line above ?  sizeof(dest) is a const value
(typically 4 or 8) !

I agree with Olaf that string_copy() is usefulness.

I suggest you to improve the check of the string length before the copy
(not in the copy function), and raising an error when the length of the
string is too long.

Regards
G.Baroncelli
