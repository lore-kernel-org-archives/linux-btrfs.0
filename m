From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: [PATCH v3 4/8] scrub: bugfix: mirror_num off by one
Date: Tue, 19 Jul 2011 17:00:11 +0200
Message-ID: <4E259BFB.1020302@jan-o-sch.net>
References: <cover.1310053204.git.list.btrfs@jan-o-sch.net> <a841550267e24b620e00d472bb40bb661005f559.1310053204.git.list.btrfs@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a841550267e24b620e00d472bb40bb661005f559.1310053204.git.list.btrfs@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 07.07.2011 17:48, Jan Schmidt wrote:
> Fix the mirror_num determination in scrub_stripe. The rest of the scrub code
> did not use mirror_num for anything important and that error went unnoticed.
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This just turned out not to be the case. Please ignore this. I'll send a
corrected version, soon.

The bug introduced with this series does nothing harmful by itself, but
can prevent error correction.

-Jan
