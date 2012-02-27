From: David Sterba <dave@jikos.cz>
Subject: Re: Errors in dmesg, no crashes though.
Date: Mon, 27 Feb 2012 16:03:46 +0100
Message-ID: <20120227150346.GQ1046@twin.jikos.cz>
References: <CACCfv7p=w3j5+K698nms0-T1XJLXg=SWhQQ82jf7yvSUt9nYPw@mail.gmail.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, josef@redhat.com
To: Jordan Windsor <jordanw2@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CACCfv7p=w3j5+K698nms0-T1XJLXg=SWhQQ82jf7yvSUt9nYPw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 25, 2012 at 09:14:01AM +1030, Jordan Windsor wrote:
> I'm running Ubuntu under KVM, with btrfs on the host where the
> Qemu/KVM image is stored, the VM was also running at the time. I was
> going to check something unrelated in the dmesg output, as I did that
> I noticed some errors in it about btrfs here they are:
> 
> 
> [ 4294.431807] btrfs: block rsv returned -28
> [ 4294.431811] ------------[ cut here ]------------
> [ 4294.431831] WARNING: at fs/btrfs/extent-tree.c:5985

This is a warning and it shows up from time to time, accross recent
releases.

> This didn't cause any crashes or related issues, also unrelated (I
> think?) is that I get very low performance (about 5MBps according to
> iostat) in a guest under Qemu/KVM.
> 3.2.7-1-ARCH x86_64 Arch Linux

Yes, the performance goes down as some pathological should-not-happen
code path is taken. I myself haven't seen this error recently during
testing, but at the time I did, it slowed down the machine for a while,
ie. it's not a inifinite loop. Seems there's a dark corner of
space reservations left for Josef.


david
