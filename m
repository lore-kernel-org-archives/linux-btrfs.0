Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f176.google.com ([74.125.82.176]:50016 "EHLO
        mail-ot0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753107AbdKFUEt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Nov 2017 15:04:49 -0500
Received: by mail-ot0-f176.google.com with SMTP id c47so10094680otj.6
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Nov 2017 12:04:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
References: <CAD8FQQ0tO3AZDDh89hczwZ1pL70uom5EBY2fbZWm_LDJAQE2UQ@mail.gmail.com>
 <CAD8FQQ3kBfy8kLFzSm-OVbsYsQ7-LzH0faD09__4S5_q0bM7pA@mail.gmail.com>
 <CAKuJGC-aRt_NKboYa9ZK6ApWDJ_knM-UazPxEUq7sHiNXEqA6w@mail.gmail.com>
 <CAD8FQQ20m3sgLKc_utf2xb-J6bhf1W58mAkEFc2jyJy7-bH3+w@mail.gmail.com>
 <CAD8FQQ3boTj97yu-F8CiFBvR-EfD+1chcSo=VzyAxwO7GpomEg@mail.gmail.com>
 <CAKuJGC8omM8TMg7DqncuoM6e0jdUOdiwNLU6q29z__U=2NQHvg@mail.gmail.com>
 <1484297967.48018.1508985286675@email.1and1.com> <CAJCQCtS9he3cpqKgnFQjM2GPA1atvgfmi2ZhrjGZg8Yq1h91BQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 6 Nov 2017 13:04:48 -0700
Message-ID: <CAJCQCtSR3aSe5OfEW3A2vxvv8j71pqTu-mOeYSvjaKhGogT=Jg@mail.gmail.com>
Subject: Re: btrfs send yields "ERROR: send ioctl failed with -5: Input/output error"
To: Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Zak Kohler <y2k@y2kbugger.com>,
        "Lakshmipathi.G" <lakshmipathi.g@gmail.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Oct 29, 2017 at 1:05 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Oct 26, 2017 at 4:34 AM, Zak Kohler <y2k@y2kbugger.com> wrote:
>
>> I will gladly repeat this process, but I am very concerned why this
>> corruption happened in the first place.
>
> Right. So everyone who can, needs to run the three scrubs on all
> available Btrfs volumes/devices and see if they get any discrepancies.

I've just done this test with five Btrfs volumes of various ages, and
a total of a few TB. There were no errors, and no discrepancies
between the three scrubs. What is needed for more thorough testing is
corrupt metadata and data (unrelated), and see how the three scrubs
report those corruptions. More information in the new thread "feedback
on three different scrub methods"


-- 
Chris Murphy
