From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: fstrim on BTRFS
Date: Thu, 29 Dec 2011 11:29:08 +0700
Message-ID: <CAG1y0scg0vA1jfrp7GX8m9Puh0HJWBNgABHiXqrOuUGgH6p8KQ@mail.gmail.com>
References: <201112281757.16019.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112281757.16019.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 28, 2011 at 11:57 PM, Martin Steigerwald
<Martin@lichtvoll.de> wrote:
> But BTRFS does not:
>
> merkaba:~> fstrim -v /
> /: 4431613952 bytes were trimmed
> merkaba:~> fstrim -v /
> /: 4341846016 bytes were trimmed

.... and apparently it can't trim everything. Or maybe my kernel is
just too old.


$ sudo fstrim -v /
2258165760 Bytes was trimmed

$ df -h /
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda6              50G   34G   12G  75% /

$ mount | grep "/ "
/dev/sda6 on / type btrfs (rw,noatime,subvolid=258,compress-force=lzo)

so only about 2G out of 12G can be trimmed. This is on kernel 3.1.4.

-- 
Fajar
