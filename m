From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Mass-Hardlinking Oops
Date: Mon, 12 Oct 2009 06:43:19 +0800
Message-ID: <3d0408630910111543t23bdf6c3u2274efc65f0fe06c@mail.gmail.com>
References: <4A74401B.90801@mccme.ru> <20090803145741.GC3765@think>
	 <4A76FB78.5000207@wpkg.org> <20090803235920.C13173@mccme.ru>
	 <87my3y3r8u.fsf@faran.nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?P=E4r_Andersson?= <paran@lysator.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87my3y3r8u.fsf@faran.nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 11, 2009 at 11:05 PM, P=E4r Andersson <paran@lysator.liu.se=
> wrote:
> Mikhail Raskin <raskin@mccme.ru> writes:
>
>> On Mon, 3 Aug 2009, Tomasz Chmielewski wrote:
>>> BTW, what limit is that?
>>
>> 272 links. Creating 273-th link causes BUG(). The limit seems so
>> arbitrary that it maybe can be made higher.. 32-bit (billions of
>> links) seem totally unrestrictive..
>
> I just ran into the max hard link per directory limit, and remembered
> this thread. I get EMLINK when trying to create more than 311 (not 27=
2)
> links in a directory, so at least the BUG() is fixed.

The max number of hard link is depend on total length of hard link
names.

>
> What is the reason for the limit, and is there any chance of increasi=
ng
> it to something more reasonable as Mikhail suggested?

The limit is imposed by the format of inode back references. We can
get rid of the limit, but it requires a disk format change.

Regards
Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
