From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: Issues with KVM
Date: Fri, 22 Jul 2011 14:59:18 -0500
Message-ID: <CAGAVQTGdEQdS+rE-D=fd4GXgaufpdR6J5xgNUjRa+N402Ge5-g@mail.gmail.com>
References: <4E29D318.7050602@haypocalc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Victor Stinner <victor.stinner@haypocalc.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E29D318.7050602@haypocalc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 22, 2011 at 2:44 PM, Victor Stinner
<victor.stinner@haypocalc.com> wrote:
> =C2=A0Hi,
>
> I have a new fast computer to run many virtual machines. Everything l=
ooks
> very fast, except the installation of new operating systems in KVM. T=
he
> installation is very fast until it begins to write on disk. It looks =
like it
> writes slower and slower. I tried Debian, FreeBSD, OpenIndiana and Op=
enBSD:
> same problem. The FreeBSD installer displays the speed: it starts at =
780
> KB/sec (which it already very slow) to finish between 1 and 8 KB/sec.

) is the host FS btrfs?
) are virtio modules in the initramfs (or kernel probably)?
) are you sure virtio is being used (eg. are the disks called vdX vs sd=
X)?
) is the disk bus set to virtio (virtmanager)?
) is the disk's cache mode set to none [or maybe writeback] (virtmanage=
r)?
) is the disk's storage format set to "raw", should be (virtmanager)?
) is caching enabled on the image? ()

probably need to change the cache mode on the disk, or if the host is
btrfs you need to flag the image with whetever is needed to prevent
continuous COWing.

C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
