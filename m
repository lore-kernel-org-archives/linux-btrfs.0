From: David Nicol <davidnicol@gmail.com>
Subject: hard links across snapshots/subvolumes are actually a bad idea.
Date: Wed, 24 Nov 2010 16:07:28 -0600
Message-ID: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been thinking about this for a while, from a perspective of how
to make it work by allocating i-node numbers from a global pool, but
yesterday I realized that offering the feature would be a bad idea
because it violates the semantics of file systems.

I will be happy to expand on that point if anyone disagrees with it.

dln

-- 
"It is merely a matter of persistence." -- Albert Camus
