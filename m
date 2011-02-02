From: Chris Samuel <chris@csamuel.org>
Subject: Re: Intermittent ENOSPC in 2.6.38rc2 (BUG linux/fs/btrfs/inode.c:1759)
Date: Wed, 02 Feb 2011 17:05:35 +1100
Message-ID: <4D48F42F.6020204@csamuel.org>
References: <AANLkTim5AK5ej9chxZu2TFFOEPL5S62+d+ABVOWucodx@mail.gmail.com> <AANLkTimJA+cT7LvtwTuWBroQA5GVv8HvTcGO7g=PGsqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimJA+cT7LvtwTuWBroQA5GVv8HvTcGO7g=PGsqw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/02/11 16:41, cwillu wrote:

> Building btrfs from josef's tree seems to clear this up,
> I was able to build dozens of times without errors.

Interesting, I wonder what fixes it ?

-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
