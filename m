From: cwillu <cwillu@cwillu.com>
Subject: Re: btrfs: block rsv returned -28
Date: Fri, 24 Feb 2012 20:37:26 -0600
Message-ID: <CAE5mzvhzsHDU=HU9_MTcp8ptA25tcn7HkxqOE1SNqznvRk9eMQ@mail.gmail.com>
References: <4F4846E1.50307@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Christian Robert <christian.robert@polymtl.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F4846E1.50307@polymtl.ca>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 24, 2012 at 8:26 PM, Christian Robert
<christian.robert@polymtl.ca> wrote:
> Hi,
>
> I ran a quite heavy script who create 10,000 subvolumes and then delete
> thoses 10,000 subvolumes.
>
> No problems in the "create" part, but at the "delete" part
> I got several traceback from the kernel:
>
[snip]
>
> and finally the partition cannot be unmounted and I had to reboot.
>
> well, it's probably not that important, who the hell will be deleting 10,000
> subvolumes
> in a 2 minutes timeframe ?

Deletion works in the background, and involves a walk over the
contents being deleted.  I'm fairly sure that unmounting blocks on the
completion of that background process, which could take quite some
time in this case.
