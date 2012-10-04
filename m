Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36317 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932965Ab2JDARz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 20:17:55 -0400
Received: by oagh16 with SMTP id h16so8070672oag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 03 Oct 2012 17:17:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506CB7F4.9040705@middelthun.no>
References: <506C6934.5010904@middelthun.no>
	<CAKcLGm_Y9iomb2eroXULoQPiueA9Gpx_BcJ-MeFm6V+JraXUqA@mail.gmail.com>
	<506CB7F4.9040705@middelthun.no>
Date: Wed, 3 Oct 2012 19:17:54 -0500
Message-ID: <CAKcLGm-03F6au5LOdJH-_cd2YHexPFiNfsh_tX2SM+c=-P9MUw@mail.gmail.com>
Subject: Re: tree root
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: =?ISO-8859-1?Q?=D8ystein_S=E6ttem_Middelthun?=
	<oystein@middelthun.no>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 3, 2012 at 5:11 PM, Øystein Sættem Middelthun
<oystein@middelthun.no> wrote:
> On 10/03/2012 07:29 PM, Mitch Harder wrote:
>>
>> If you do not have a suitable backup for these files, please make an
>> effort to do what you can with restore.  Some of the repair methods
>> out there have a possibility to make the situation worse.
>
>
> We are talking about something like 50TB, so there is just no way I have the
> available space on other disks for temporary storage.
>
> So in effect you are saying that there are no other available options than a
> restore? If I understand correctly a feature along the lines of "mount -o
> tree_root=14102764707840 /dev/ /path/" would solve my problem.
>
> The fs is unmountable because of a temporary loss of connection with an
> underlying disk controller, and I don't think the device has a lot of errors
> besides not being able to find the latest tree root.
>

You should probably try to supply some more information about your situation.

Was this btrfs volume build with RAID-1?

If so, we should be able to mount in degraded mode.

Even so, when I see the words "unable to find the tree root" and
"temporary loss of connection with an underlying disk controller"
along with the implication that you have no reliable backup of this
data, I worry that your situation is potentially precarious.

The possibility exists that recovering your data is your best option
(as opposed to restoring to previous working condition).

Using backup tree-roots and super-blocks has the potential to do
irreversible damage.
