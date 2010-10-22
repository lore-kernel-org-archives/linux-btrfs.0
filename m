From: C Anthony Risinger <anthony@extof.me>
Subject: Re: [PATCH] Btrfs: add support for mixed data+metadata block groups V3
Date: Thu, 21 Oct 2010 20:32:12 -0500
Message-ID: <AANLkTinS-3kQaMbd-uAW+y4bzEhJPj7W1oJFRPQ2r-26@mail.gmail.com>
References: <1286452263-1635-1-git-send-email-josef@redhat.com>
	<AANLkTi=9uDOLNk3JnLN=okVWwSZBvfpSdMwvAWkMJK0g@mail.gmail.com>
	<AANLkTik4xa+TKqP-4Hp2FErmbLUh0qu-ge-0qiHfBLuZ@mail.gmail.com>
	<201010220009.26464.diegocg@gmail.com>
	<AANLkTik+nk4-zfrF+Z++FDt0QgM5KTWGGTHi0CfQ69XY@mail.gmail.com>
	<20101022010521.GG30906@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Mitch Harder <mitch.harder@sabayonlinux.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101022010521.GG30906@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 21, 2010 at 8:05 PM, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Oct 21, 2010 at 05:21:06PM -0500, Mitch Harder wrote:
>> On Thu, Oct 21, 2010 at 5:09 PM, Diego Calleja <diegocg@gmail.com> w=
rote:
>> > On Jueves, 21 de Octubre de 2010 17:46:58 David Nicol escribi=F3:
>> >> Does this mixing constitute a forbidden change of on-disk format,=
 and
>> >> if not how not?
>> >
>> > It doesn't need a format change. The difference between a data and
>> > a metadata block group is just an allocation hint AFAIK.
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-bt=
rfs" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>> Let me know if the problems with an un-patched kernel were un-expect=
ed.
>>
>> I can provide more information on the crash when booting an older ke=
rnel.
>
> Nope they are expected, it's not a disk format change, but older kern=
els won't
> deal with mixed block groups.

When something like this goes mainline, is it used by default/automatic=
ally?

I ask because I maintain a btrfs-based rollback initramfs hook [1],
and am currently updating it for extlinux, enabling kernel-level
system rollbacks via `btrfs set-default` + reboot (or maybe
`kexec`)...

rolling back to an old kernel will then blow up my machine
(figuratively of course :-)?

C Anthony

[1] http://aur.archlinux.org/packages.php?ID=3D33376
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
