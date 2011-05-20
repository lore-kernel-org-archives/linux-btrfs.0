From: Miguel Garrido <miguel@mjgar.com>
Subject: Re: What are thoses [btrfs-cache-nnn] kernel threads ?
Date: Thu, 19 May 2011 23:13:13 -0400
Message-ID: <BANLkTik5vAoZrY0H=y+2v5i91x8FvsxRYQ@mail.gmail.com>
References: <4DD4825D.4060706@polymtl.ca>
	<20110519182612.GD18123@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110519182612.GD18123@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 19, 2011 at 2:26 PM, Josef Bacik <josef@redhat.com> wrote:
>
> Yeah so this is a crappy thing about btrfs, we need to cache free spa=
ce, so we
> have to run these threads to read the extent tree to put together the=
 free space
> cache. =A0You can get around this by moving to a new kernel and mount=
ing with
>
> -o space_cache
>
> This will enable the space caching feature, so you will get those thr=
eads once,
> but then every time after that it will be fast and you shouldn't see =
those
> threads at all. =A0Its a disk format change, so you only have to moun=
t -o
> space_cache once and then it will be permament. =A0Thanks,
>
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Out of curiosity, why isn't this done automatically as opposed to
having to mount with the space_cache option?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
