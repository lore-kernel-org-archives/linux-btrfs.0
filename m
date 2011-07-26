From: Josef Bacik <josef@redhat.com>
Subject: ENOSPC overhaul
Date: Tue, 26 Jul 2011 14:13:51 -0400
Message-ID: <4E2F03DF.9030302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm going to be going through our ENOSPC handling to make it simpler and
fixing the various performance problems and too early problems we have
been seeing.  I'm going to target these for 3.2, but I'm going to post
them as I churn them out so people can review them and test them.
Please respond to this email with your pet-ENOSPC test, I want to make
sure we are in good standing when the merge window opens for 3.2 so we
don't ever have to worry about this problem again (at least in the big
general sense that we have had to in the past).  Thanks,

Josef
