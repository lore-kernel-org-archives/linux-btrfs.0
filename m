From: Spelic <spelic@shiftmail.org>
Subject: Re: [GIT PULL] Btrfs updates
Date: Wed, 19 Jan 2011 10:15:44 +0100
Message-ID: <4D36ABC0.1060109@shiftmail.org>
References: <1295298216-sup-6206@think> <20110118101436.GA2652@scooter>
 <AANLkTimDGtzw9GSC7FigFsKO+w9cO30LUZ2=XK0aK9Hj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTimDGtzw9GSC7FigFsKO+w9cO30LUZ2=XK0aK9Hj@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 01/18/2011 04:22 PM, C Anthony Risinger wrote:
> On Tue, Jan 18, 2011 at 4:14 AM, Felix Blanke<felixblanke@gmail.com>  wrote:
>    
>
> i don't know about the readonly snapshots, but the LZO stuff is a
> mount option; should be in the pull.
>
> and for the record, i'm totally stoked to run LZO on all my btrfs
> machines (esp. the netbooks/SSDs :-)
>    

Excuse the newbie question: how does Btrfs deal with the compressed data 
not being block aligned anymore?
E.g. suppose you have a LZO compressed file, then a program rewrites 
some data which is in the middle of the file, and suppose the newly 
written data is less compressible.

Btrfs is a copy-on-write FS so this simplifies things a bit, 
nevertheless it has to support the fact that after the rewrite there 
will in general be 2 or 3 blocks in the middle of the file which are not 
completely full: probably the one where old data ends and new data 
starts will be truncated, a few new blocks will be allocated for newly 
written data (which won't in general end at a block bounday so this is 
the second block which is not completely full) and then the place where 
old data restarts will again be not a full block.
Is btrfs capable of that? If yes, calculating offsets in files for 
random reads is going to be quite a bit slower...

Also, if yes, this could significantly impact data deduplication, in 
both positive and negative ways:
positive: (with a lot of work) btrfs could detect and merge equal parts 
at different offsets in different files, even not block aligned.
negative: (without a lot of work) if for some reason one of the first 
blocks in a file gets truncated and all the rest of the file gets hence 
shifted forward (but this could probably happen only during the first 
write of that file, maybe if lzo was turned on and then off again), data 
deduplication won't probably work for that file... ok this might not be 
big issue.


