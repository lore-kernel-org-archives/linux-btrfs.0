From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH] Btrfs: add support for mixed data+metadata block groups V3
Date: Thu, 21 Oct 2010 17:21:06 -0500
Message-ID: <AANLkTik+nk4-zfrF+Z++FDt0QgM5KTWGGTHi0CfQ69XY@mail.gmail.com>
References: <1286452263-1635-1-git-send-email-josef@redhat.com>
	<AANLkTi=9uDOLNk3JnLN=okVWwSZBvfpSdMwvAWkMJK0g@mail.gmail.com>
	<AANLkTik4xa+TKqP-4Hp2FErmbLUh0qu-ge-0qiHfBLuZ@mail.gmail.com>
	<201010220009.26464.diegocg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010220009.26464.diegocg@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 21, 2010 at 5:09 PM, Diego Calleja <diegocg@gmail.com> wrot=
e:
> On Jueves, 21 de Octubre de 2010 17:46:58 David Nicol escribi=F3:
>> Does this mixing constitute a forbidden change of on-disk format, an=
d
>> if not how not?
>
> It doesn't need a format change. The difference between a data and
> a metadata block group is just an allocation hint AFAIK.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Let me know if the problems with an un-patched kernel were un-expected.

I can provide more information on the crash when booting an older kerne=
l.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
