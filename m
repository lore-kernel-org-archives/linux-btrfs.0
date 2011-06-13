From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: use the normal checksumming infrastructure for free space cache
Date: Sun, 12 Jun 2011 21:53:17 -0400
Message-ID: <1307929964-sup-6781@shiny>
References: <1307734827-10697-1-git-send-email-josef@redhat.com> <4DF56D60.4070208@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DF56D60.4070208@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2011-06-12 21:52:32 -0400:
> Josef Bacik wrote:
> > We used to store the checksums of the space cache directly in the space cache,
> > however that doesn't work out too well if we have more space than we can fit the
> > checksums into the first page.  So instead use the normal checksumming
> > infrastructure.  There were problems with doing this originally but those
> > problems don't exist now so this works out fine.  Thanks,
> > 
> 
> This looks great, so I'll drop my patch that extends the original code to
> allow more than 1 crc page.

I do like them a lot, but what happens when a special case crc kernel
mounts a free space cache created by this patch?

-chris
