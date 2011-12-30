From: =?us-ascii?Q?Jaromir=20Zdrazil?= <jaromir.zdrazil@email.cz>
Subject: =?us-ascii?Q?data=20integrity=20in=20btrfs?=
Date: Fri, 30 Dec 2011 14:29:46 +0100 (CET)
Message-ID: <135528.24428.61333-23184-1070446607-1325251786@email.cz>
Reply-To: jaromir.zdrazil@email.cz
Mime-Version: 1.0
Content-Type: text/plain;	charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi again,

   I know that ZFS include data integrity verification against data corruption modes using propably SHA256.

   By sketchy readings at https://btrfs.wiki.kernel.org/index.html , http://en.wikipedia.org/wiki/Btrfs and other sources I have found just that there is Sha32C used and that it should be similar to ZFS.

   How are data faults detected and repaired ni BRTFS? If the answer could be simple and precize, I would be more than happy.

Thank you! Gone to lunch ;O)

Jaromir
