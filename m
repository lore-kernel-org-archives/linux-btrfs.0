From: Peter A <loony@loonybin.org>
Subject: Re: Offline Deduplication for Btrfs
Date: Thu, 6 Jan 2011 08:33:15 -0500
Message-ID: <201101060833.15627.loony@loonybin.org>
References: <1294245410-4739-1-git-send-email-josef@redhat.com> <201101052258.36457.loony@loonybin.org> <4D259DF2.8090200@bobich.net>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D259DF2.8090200@bobich.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday, January 06, 2011 05:48:18 am you wrote:
> Can you elaborate what you're talking about here? How does the length of
> a directory name affect alignment of file block contents? I don't see
> how variability of length matters, other than to make things a lot more
> complicated.
I'm saying in a filesystem it doesn't matter - if you bundle everything into a 
backup stream, it does. Think of tar. 512 byte allignment. I tar up a 
directory with 8TB total size. No big deal. Now I create a new, empty file in 
this dir with a name that just happens to be the first in the dir. This adds 
512 bytes close to the beginning of the tar file the second time I run tar. Now 
the remainder of the is all offset by 512bytes and, if you do dedupe on fs-
block sized chunks larger than the 512bytes, not a single byte will be de-
duped. 
I know its a stupid example but it matches the backup-target and database dump 
usage pattern really well. Files backing iSCSI shows similar dedupe behavior. 
Essentially every time you bundle mutliple files together into one you run into 
things like that.
 
> Have you some real research/scientifically gathered data
> (non-hearsay/non-anecdotal) on the underlying reasons for the
> discrepancy in the deduping effectiveness you describe? 3-17x difference
> doesn't plausibly come purely from fixed vs. variable length block sizes.
Personal experience isn't hearsay :) Netapp publishes a whitepaper against the 
7000 making this a big point but that isn't publicly available. Try search 
"zfs dedupe +netbackup" or "zfs dedupe +datadomain" and similar - you will 
hear of hundreds of people all complain about the same thing.

> The only case where I'd bother consider variable length deduping is in
> file deduping (rather than block), in this case we can just make a COW
> hard-link and it's _really_ cheap and effective.
I take your word for this :) 

> 
> Gordan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Censorship: noun, circa 1591. a: Relief of the burden of independent thinking.
