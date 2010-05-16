From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Mounting raid without a btrfsctl scan
Date: Sun, 16 May 2010 20:44:23 +0200
Message-ID: <201005162044.23272.kreijack@libero.it>
References: <4BEE817A.7060604@gmx.com> <20100516000257.GB651@mother.pipebreaker.pl> <AANLkTinRVuk_uJBLsBD0ANdKkEHs-9zz4Tor_0xi7oCI@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinRVuk_uJBLsBD0ANdKkEHs-9zz4Tor_0xi7oCI@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 16 May 2010, Sebastian 'gonX' Jensen wrote:
> On 16 May 2010 02:02, Tomasz Torcz <tomek@pipebreaker.pl> wrote:

[...]
> I don't know if I mentioned it before, but my system
> spends at least 6 seconds in the initramfs before passing control over
> to my distributions initscripts. Part of it is obviously because of
> btrfs having to spend approximately 3 seconds probing for devices (I
> have a decent amount of devices). 


> However, btrfs does not have that
> many functions yet. Would it be possible to at least have partial
> functionality kernel side, so that an initramfs is not required for
> mounting RAID devices?

I think that the good question is: why a kernel probing should be faster than 
a user space probing ? 

I think that some reasons of the time required by the btrfsctl scan in user 
space are:
1) a scan performed via 'btrfsctl -a' scans every block device (cdrom and 
floppy included). I suggest to perform a scan via udev (see my previous post); 
that should be reduce the boot time.
2) the actual initramfs tools pay attention to wait that _all_ devices 
appeared. This requires a bit of time which is not related to the "user space" 
scan.

Comments ?

G.Baroncelli

> 
> > --
> > Tomasz Torcz              ,,If you try to upissue this patchset I shall be 
seeking
> > xmpp: zdzichubg@chrome.pl   an IP-routable hand grenade.'' -- Andrew 
Morton (LKML)
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
