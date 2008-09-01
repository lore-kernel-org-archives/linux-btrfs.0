From: Balaji Rao <balajirrao@gmail.com>
Subject: Transparent compression for Btrfs
Date: Mon, 1 Sep 2008 07:39:29 +0530
Message-ID: <200809010739.29862.balajirrao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

For a medium term project, I'm thinking of working on transparent compression 
for Btrfs. Please give any hints and comments on how we would want to go 
about this, the features we would like to have and some common pitfalls to 
avoid.

Is looking at how it's done in Reiser4, a good idea ? Can we allow the 
compression algorithm be configurable on a per file basis, may be using an 
xattr ? This, for example, would allow us to make a compromise between speed 
and compression ratio.

Any other ideas welcome.

-- 
Thanks,
Balaji Rao
