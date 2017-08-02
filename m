Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:35248 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750850AbdHBWMH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 18:12:07 -0400
Received: by mail-qt0-f176.google.com with SMTP id p3so35105132qtg.2
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Aug 2017 15:12:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <05695141-f23a-e0f7-dba5-d23f65681283@fb.com>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za> <05695141-f23a-e0f7-dba5-d23f65681283@fb.com>
From: "Fajar A. Nugraha" <list@fajar.net>
Date: Thu, 3 Aug 2017 05:12:05 +0700
Message-ID: <CAG1y0seO6FgLQTSYY9EqbSDrT=9dkxrr6E3EV3=rXYKfBv3s_Q@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 3, 2017 at 1:44 AM, Chris Mason <clm@fb.com> wrote:
>
> On 08/02/2017 04:38 AM, Brendan Hide wrote:
>>
>> The title seems alarmist to me - and I suspect it is going to be misconstrued. :-/
>
>
> Supporting any filesystem is a huge amount of work.  I don't have a problem with Redhat or any distro picking and choosing the projects they want to support.
>

It'd help a lot of people if things like
https://btrfs.wiki.kernel.org/index.php/Status is kept up-to-date and
'promoted', so at least users are more informed about what they're
getting into and can choose which features (stable/still in dev/likely
to destroy your data) that they want to use.

For example, https://btrfs.wiki.kernel.org/index.php/Status says
compression is 'mostly OK' ('auto-repair and compression may crash'
looks pretty scary, as from newcomers-perspective it might be
interpretted as 'potential data loss'), while
https://en.opensuse.org/SDB:BTRFS#Compressed_btrfs_filesystems says
they support compression on newer opensuse versions.


>
> At least inside of FB, our own internal btrfs usage is continuing to grow.  Btrfs is becoming a big part of how we ship containers and other workloads where snapshots improve performance.
>

Ubuntu also support btrfs as part their container implementation
(lxd), and (reading lxd mailing list) some people use lxd+btrfs on
their production environment. IIRC the last problem posted on lxd list
about btrfs was about how 'btrfs send/receive (used by lxd copy) is
slower than rsync for full/initial copy'.

-- 
Fajar
