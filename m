From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: feature request: usrquota support
Date: Thu, 31 Mar 2011 05:42:54 +0200
Message-ID: <AANLkTinoWxVGVM=1YdBcTR-V4Vy-fgMOAioPBo-+jy+Z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

usrqouta is very usefull for couting (and limitng) ammount of data put
by system users. Its otherwise impossible to quicly calculate disc
usage by system users. Btrfs sould support this in future. Usrquota is
supported by ext2/ext3/reiserfs and I quess it updates its internal
database everytime file is created, deleted, resized or changed
ownership...
