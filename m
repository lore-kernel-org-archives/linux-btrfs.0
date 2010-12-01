From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: What to do about subvolumes?
Date: Wed, 1 Dec 2010 20:08:49 +0100
Message-ID: <201012012008.49386.kreijack@libero.it>
References: <20101201142136.GD427@dhcp231-156.rdu.redhat.com> <AANLkTi=2z9RwiiD+ohhqB-WDf9uFXYoko3VhjOjmiY=5@mail.gmail.com> <AANLkTimPx+u-bJH+beEP4kr6Bb3qJh1EryriHxeLDsj_@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: chris.mason@oracle.com, ssorce@redhat.com,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Josef Bacik <josef@redhat.com>
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimPx+u-bJH+beEP4kr6Bb3qJh1EryriHxeLDsj_@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, 01 December, 2010, you (C Anthony Risinger) wrote:
[...]
> i forgot to mention, but a quick 'n dirty solution would be to simply
> not enable users to do this by accident.  mkfs.btrfs could create a
> new subvol, then mark it as default... this way the user has to
> manually mount with id=0, or remark 0 as the default.
> 
> effectively, users would be unknowingly be installing into a
> subvolume, rather then the top-level root (apologies if my terminology
> is incorrect).

I fully agree: it fulfill the KISS principle :-)

> C Anthony
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
