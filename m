From: Chris Ball <cjb@laptop.org>
Subject: Re: Slow link/Capacity changed + Kernel OOPS... possible hardware issues, ideas?
Date: Thu, 07 Oct 2010 23:20:35 -0400
Message-ID: <m37hhtmku4.fsf@pullcord.laptop.org>
References: <AANLkTikcaAFvosjpnZpG9Rp8C1Q+nqb1=Uaftyzh5fXp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikcaAFvosjpnZpG9Rp8C1Q+nqb1=Uaftyzh5fXp@mail.gmail.com>
	(C. Anthony Risinger's message of "Thu, 7 Oct 2010 22:07:47 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > can anyone point me in the right direction?  it looks like maybe
   > the SSD is failing to me (all the "slow link" and "capacity
   > changed to 0" stuff), but i really don't know.  i knew there was
   > a reason they were selling these things cheap on Newegg!!!

Yes, the read errors are coming all the way up from the hardware;
I don't think this is a btrfs problem.

There's not much btrfs could do to help, except (over time) grow
to handle I/O errors without BUG()ing out.

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
