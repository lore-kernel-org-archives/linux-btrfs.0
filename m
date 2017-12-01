Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:38376 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751891AbdLAMIz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 07:08:55 -0500
Received: by mail-lf0-f51.google.com with SMTP id e137so11480170lfg.5
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Dec 2017 04:08:55 -0800 (PST)
MIME-Version: 1.0
From: Eric Mesa <ericsbinaryworld@gmail.com>
Date: Fri, 1 Dec 2017 07:08:53 -0500
Message-ID: <CAKYHq8L9PX8aBG4of1kohMyqQgT27pzP4yFJunsvMud0rj+tTg@mail.gmail.com>
Subject: RE: btrfs-progs - failed btrfs replace on RAID1 seems to have left
 things in a wrong state
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan,

Thank you for your thorough response to my problem. I am now wiser in
my understanding of how btrfs works in RAID1 thanks to your words.
Last night I worked with someone in the IRC channel and we essentially
came to the exact same conclusion. I used wipefs -a on the errant
drive. Rebooted and viola. As of last night the replace was running
fine. (Didn't have time to check this morning before heading out) The
people on IRC had recommended filing a bug based on the fact that a
btrfs filesystem was created during the replace, but if I understand
your feedback, this has already been noted and there are patches being
considered.

As for your backup feedback, it has been thoroughly beaten into my
head over the last half-decade that RAID is not backup. Although, I'd
argue that RAID on btrfs or ZFS making use of snapshots is pretty darn
close. (Since it covers the fat-finger situation - although it doesn't
cover the MOBO frying your hard-drives situation) But I do have
offsite backup - it's just that it's with a commercial provider (as
opposed to, say, a friend's house) so I didn't want to have to
download 3TB if things got borked. (I consider that my house
burning/theft backup) And it IS in the plans to have a separate backup
system in my house. I just haven't spent the money yet as it's
currently a bit tight. But I do appreciate that you took the time to
explain that in case I didn't know about it. And it's on the mailing
list archives now so if someone else is under the misunderstanding
that RAID is backup they can also be educated.

Anyway, this is running a bit long. I just want to conclude by again
offering my thanks at your very thorough response. If I hadn't been
able to obtain help on the IRC, this would have put me on the right
path. And it came with knowledge rather than just a list of
instructions. So thanks for that as well.
--
Eric Mesa
http://www.ericmesa.com
