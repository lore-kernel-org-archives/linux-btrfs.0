From: cwillu <cwillu@cwillu.com>
Subject: Re: Intermittent ENOSPC in 2.6.38rc2 (BUG linux/fs/btrfs/inode.c:1759)
Date: Wed, 2 Feb 2011 00:15:22 -0600
Message-ID: <AANLkTi=-dxU4aEv+rSD8DsL2OvYOya4zhscPWp1vKp60@mail.gmail.com>
References: <AANLkTim5AK5ej9chxZu2TFFOEPL5S62+d+ABVOWucodx@mail.gmail.com>
	<AANLkTimJA+cT7LvtwTuWBroQA5GVv8HvTcGO7g=PGsqw@mail.gmail.com>
	<4D48F42F.6020204@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D48F42F.6020204@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 2, 2011 at 12:05 AM, Chris Samuel <chris@csamuel.org> wrote:
> On 02/02/11 16:41, cwillu wrote:
>
>> Building btrfs from josef's tree seems to clear this up,
>> I was able to build dozens of times without errors.
>
> Interesting, I wonder what fixes it ?

The error was an ENOSPC, which was specifically why josef had me try that tree.
