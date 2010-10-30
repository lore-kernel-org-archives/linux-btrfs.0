From: Chris Ball <cjb@laptop.org>
Subject: Re: Blog: "BTRFS is effectively stable"
Date: Fri, 29 Oct 2010 22:04:57 -0400
Message-ID: <m3hbg48mgm.fsf@pullcord.laptop.org>
References: <201010301038.28038.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010301038.28038.chris@csamuel.org> (Chris Samuel's message of
	"Sat, 30 Oct 2010 10:38:23 +1100")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > A friend of mine who builds storage systems designed for HPC use
   > has been keeping an eye on btrfs and has just done some testing
   > of it with 2.6.36 and seems to like what he sees in terms of
   > stability.
   > 
   > http://scalability.org/?p=2711

This is nice to see, but we should be clearer about what stability
means.  This was just fio testing; it doesn't say anything about
resilience to crashes, power offs, or the presence of corruption.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
