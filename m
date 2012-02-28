From: Karel Zak <kzak@redhat.com>
Subject: Re: LABEL only 1 device
Date: Tue, 28 Feb 2012 23:35:57 +0100
Message-ID: <20120228223557.GA4515@x2.net.home>
References: <20120226153036.GB18898@carfax.org.uk>
 <C3b12r9i1uB@helmut.hullen.de>
 <20120226164400.GC18898@carfax.org.uk>
 <pan.2012.02.26.18.07.31@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Duncan <1i5t5.duncan@cox.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <pan.2012.02.26.18.07.31@cox.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 26, 2012 at 06:07:31PM +0000, Duncan wrote:
> Unfortunately, since gpt is reasonably new in terms of filesystem and 
> partitioning tools, there isn't really anything (mount, etc) that makes 
> /use/ of that label yet,

udev exports GPT labels and uuids by symlinks, see

  ls /dev/disk/by-partlabel/
  ls /dev/disk/by-partuuid/

you can use these links in your fstab. And if I good remember kernel
supports PARTUUID for root= command line option.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
