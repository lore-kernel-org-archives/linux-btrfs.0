From: Chris Samuel <chris@csamuel.org>
Subject: Re: strange filefrag output on btrfs
Date: Tue, 14 Jun 2011 17:52:26 +1000
Message-ID: <4DF7133A.2010001@csamuel.org>
References: <4DF38C23.7010603@gmail.com> <20110613115018.GT12709@twin.jikos.cz> <4DF629DA.4050300@gmail.com> <4DF6CD61.6050102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DF6CD61.6050102@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 14/06/11 12:54, Li Zefan wrote:

> There are two ways to calc the extent number, depending
> on whether verbose option is turned on or not.

To me that's very counter intuitive!

Maybe another way to do that is to name those two values
differently and in verbose mode report them both so people
can see that there is a match ?

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
