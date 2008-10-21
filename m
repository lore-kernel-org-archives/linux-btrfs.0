From: calin <calin@splitreflection.com>
Subject: compare COW files
Date: Mon, 20 Oct 2008 20:25:52 -0700
Message-ID: <20081021032552.2250.qmail@splitreflection.com>
Reply-To: calin@splitreflection.com
Mime-Version: 1.0
Content-Type: text/plain
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

If I make a cow copy of a file, is there a way find out whether either copy has changed?  Specifically, I'm looking for a way to figure out which files have changed since a snapshot was taken, short of traditional and time-consuming file comparisons.  It could have some interesting possibilities for monitoring and backup, to be able to quickly compare against a reference snapshot to find changes.
