From: David Brown <davidb@davidb.org>
Subject: Re: [patch 01/99] btrfs: Add btrfs_panic()
Date: Thu, 24 Nov 2011 21:42:18 -0800
Message-ID: <20111125054218.GA15522@davidb.org>
References: <20111124003533.395674389@suse.com>
 <20111124004219.933819241@suse.com>
 <20111124020533.GA14982@davidb.org>
 <4ECDAA4E.9000201@suse.com>
 <20111124063722.GB15023@davidb.org>
 <4ECEFF47.9090006@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ECEFF47.9090006@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 24, 2011 at 09:36:55PM -0500, Jeff Mahoney wrote:

>> Probably best not to, it makes them inconsistent with the rest of
>> the kernel's history when imported into git.  The body becomes the
>> commit text directly.
>
>I'll change them to do this since you're obviously correct. You're the
>first person in 10+ years to notice (or at least comment on) it,
>though. ;)

Some maintainers (and Linus as well) appears to have just fixed them
up when applying the patches.

David
