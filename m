From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Subject: Re: Data Deduplication with the help of an online filesystem check
Date: Mon, 4 May 2009 20:16:20 +0400
Message-ID: <2a31deca0905040916s43b60cf3xdc56d365b5c1d233@mail.gmail.com>
References: <20090427033331.GC17677@cip.informatik.uni-erlangen.de>
	<20090428155900.GA1722@cip.informatik.uni-erlangen.de> <49F728F6.6030307@wpkg.org>
	<20090428173251.GB7217@cip.informatik.uni-erlangen.de> <49F73FC9.3070607@partiallystapled.com>
	<49FEFBE6.40209@redhat.com> <49FEFE27.5090804@wpkg.org> <49FEFF9A.8060803@redhat.com>
	<20090504151518.GA13777@cip.informatik.uni-erlangen.de> <49FF11EE.2060404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Thomas Glanzmann <thomas@glanzmann.de>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	Michael Tharp <gxti@partiallystapled.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49FF11EE.2060404@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 4, 2009 at 8:03 PM, Ric Wheeler <rwheeler@redhat.com> wrote=
:
> Thomas Glanzmann wrote:
>
> I think that Chris already mentioned that you can (for virt OS images=
) also
> imagine using copy on write snapshots (of something that is mostly re=
ad-only
> like the OS system partitions). =A0Make 50 copy-on-write snapshots of=
 "/"
> (excluding /home) and you have an effective compression of 98% until =
someone
> rudely starts writing at least :-)
>

As far as I understand, VMware already ships this "gold image" feature
(as they call it) for Windows environments and claims it to be very
efficient.

Regards,
Andrey

> ric
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
