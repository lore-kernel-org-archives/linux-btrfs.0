From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: Space used by snapshot
Date: Thu, 17 Feb 2011 12:13:53 +0100
Message-ID: <AANLkTi=LE2poDR5sNyPJF6rQ_TpLv5pjgHRQXG0Wpt-i@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,

Is there any way how to obtain information how much space is
physically allocated by given subvolume?
I cannot find any. I'm interested in two values:

- physical space allocated by SUBVOLUME INCLUDING all space shared by
other subvolumes

- physical space allocated by SUBVOLUME EXCLUDING all space shared by
other subvolumes

Currently I can use only du, which is not reporting what I want to know.

Regards

Roman Kapusta
