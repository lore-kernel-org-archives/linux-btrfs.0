From: C Anthony Risinger <anthony@extof.me>
Subject: Re: disk space caching generation missmatch
Date: Thu, 2 Dec 2010 15:45:03 -0600
Message-ID: <AANLkTim13gde+KFOH3CNmDUYU2OSvvNdjK22+s69BOVn@mail.gmail.com>
References: <201012011746.14458.johannes.hirte@fem.tu-ilmenau.de>
	<20101201200312.GF7021@localhost.localdomain>
	<201012012222.45471.johannes.hirte@fem.tu-ilmenau.de>
	<201012012240.29525.johannes.hirte@fem.tu-ilmenau.de>
	<20101202203410.GC8805@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101202203410.GC8805@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 2, 2010 at 2:34 PM, Josef Bacik <josef@redhat.com> wrote:
>
> + =A0 =A0 =A0 if (!ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&block_gruop->lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 block_group->disk_cache_state =3D BTRFS=
_DC_SETUP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&block_group->lock);
> + =A0 =A0 =A0 }

misspelling:

block_gruop - > block_group

just noticed this glancing thru...

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
