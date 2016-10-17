Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:33098 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932125AbcJQRzl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Oct 2016 13:55:41 -0400
Received: by mail-vk0-f46.google.com with SMTP id 83so162808599vkd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Oct 2016 10:55:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
References: <CAA3ktqmhhasyk8L+W3jz9ifYw7UMoL4ueg1HQp7Co3L39xYe9Q@mail.gmail.com>
From: Kyle Manna <2bluesc@gmail.com>
Date: Mon, 17 Oct 2016 10:55:40 -0700
Message-ID: <CAM9fjH7pfgHJysaSrdAPR3FoT-8XCT+DOe_cjeHqpqieaid0fg@mail.gmail.com>
Subject: Re: Monitoring Btrfs
To: Stefan Malte Schumacher <stefan.m.schumacher@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 17, 2016 at 9:44 AM, Stefan Malte Schumacher
<stefan.m.schumacher@gmail.com> wrote:
> Hello
>
> I would like to monitor my btrfs-filesystem for missing drives. On
> Debian mdadm uses a script in /etc/cron.daily, which calls mdadm and
> sends an email if anything is wrong with the array. I would like to do
> the same with btrfs. In my first attempt I grepped and cut the
> information from "btrfs fi show" and let the script send an email if
> the number of devices was not equal to the preselected number.
>
> ...
>
> 1) Has anybody already written a script like this? After all, there is
> no need to reinvent the wheel a second time.

Not that I have a solution to your primary question regarding message
parsing, but do something different which may offer a different
perspective on your monitoring and reporting.

I employ systemd with timers to scrub my btrfs volumes[0][1] every
week.  I used to use either an OnFailure[2] trigger or my failure
monitor log (aka systemd-journal) parser[3] to send me emails if the
service failed to run.  This is a more "modern" approach to
cron.weekly + custom shell script for people that like systemd, love
it or hate it.

Recently I dropped the systemd journal parser for remote logging with
rsyslog + Papertrail[4] with a few alerts for things like "systemd
Failed to start" which indicates that the script returned a non-zero
exit code.  Papertrail then emails me when any of a handful of
machines trip up.

It's also worth noting logstash[5] (or similar) may be another way to
parse log files.  It could be a bloated overkill solution for
something that a 10 line shell script could accomplish, depends on if
you leverage it for things beyond basic log parsing.

[0] https://github.com/kylemanna/systemd-utils/blob/master/units/btrfs-scrub.service
[1] https://github.com/kylemanna/systemd-utils/blob/master/units/btrfs-scrub.timer
[2] https://github.com/kylemanna/systemd-utils/tree/master/onfailure
[3] https://github.com/kylemanna/systemd-utils/tree/master/failure-monitor
[4] https://blog.kylemanna.com/linux/logging-all-the-things-with-rsyslog-and-papertrail/
[5] https://www.elastic.co/guide/en/logstash/current/introduction.html
