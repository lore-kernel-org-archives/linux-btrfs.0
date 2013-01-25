Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw9b.glodns.net ([196.220.48.76]:59926 "EHLO fw9a.glodns.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750887Ab3AYPUe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jan 2013 10:20:34 -0500
Received: from localhost (unknown [127.0.0.1])
	by fw9a.glodns.net (Postfix) with ESMTP id C236326022
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 15:20:29 +0000 (UTC)
Received: from fw9a.glodns.net ([196.220.48.76])
	by localhost (fw9a.glodns.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id QHsJ+mFXsY2k for <linux-btrfs@vger.kernel.org>;
	Fri, 25 Jan 2013 17:20:25 +0200 (SAST)
Received: from control.glodns.net (unknown [196.220.42.40])
	by fw9a.glodns.net (Postfix) with ESMTP id 0A11B26008
	for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 17:20:25 +0200 (SAST)
Message-ID: <5102A277.9060305@swiftspirit.co.za>
Date: Fri, 25 Jan 2013 17:19:19 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Gene Czarcinski <gene@czarc.net>,
        Roman Mamedov <rm@romanrm.ru>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
References: <1359113550-23962-1-git-send-email-gene@czarc.net> <20130125175530.75402fb5@natsu> <51027AB8.6030901@czarc.net> <20130125124311.GB1371@carfax.org.uk>
In-Reply-To: <20130125124311.GB1371@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25/01/13 14:43, Hugo Mills wrote:
> On Fri, Jan 25, 2013 at 07:29:44AM -0500, Gene Czarcinski wrote:
>> On 01/25/2013 06:55 AM, Roman Mamedov wrote:
>>> On Fri, 25 Jan 2013 06:32:30 -0500
>>> Gene Czarcinski <gene@czarc.net> wrote:
>>>
>>>> This patch hits a lot of files but adds little code.  It
>>>> could be considered a bugfix,  Currently, when one of the
>>>> btrfs user-space programs is executed by a regular user,
>>>> the result if oftem a number of strange error messages
>>>> which do not indicate the real problem.  This patch changes
>>>> that situation.
>>>>
>>>> A test is performed as to whether the program is running
>>>> as root.  If it is not, issue an error message and exit.
>>>> Signed-off-by: Gene Czarcinski <gene@czarc.net>
>>> $ ls -la /dev/sda
>>> brw-rw---T 1 root disk 8, 0 Jan 15 12:11 /dev/sda
>>>
>>> The user does not have to be root, they can be a member of the group "disk" to
>>> manage this device.
>>>
>>> Also some or all of the tools accept not just a block device, but also a
>>> regular file as their parameter.
>>>
>>> Wouldn't it be better to check whether or not the running user has
>>> *write access* to the device or file to be operated on, before failing?
>> I knew there would be corner cases where root was not required for
>> execution.  After all, I do not need to be root to execute "btrfs
>> --version".  Now, is it worth the effort to determine the corner
>> cases and do you have a proposed solution as to determining what
>> privileges are needed when?  I can understand when it could be a
>> regular file but is it all that common for users to be part of group
>> disk?
>     Don't try to check all the possible success conditions beforehand
> -- that's what leads to websites that fail to work because your
> browser is not IE, but work perfectly when you change your user-agent
> string to "MSIE". This is highly frustrating for users.
>
>     Instead, try whatever it is you were trying to do (open a file,
> send an ioctl), and determine, as well as you can, why it failed by
> looking at the error codes that you get back, and report that.
> "Permission denied" -> means you don't have permissions -> you need to
> be root, or have yourself put in the disk group, or get the
> disk-management-capability. Let the user work out which of those
> solutions they need, rather than forcing them to use the one you
> thought of.
>
>     Hugo.
As Hugo suggested, I'd rather that we fix or refine the code in order to 
get better error messages. All the different exceptions to requiring or 
not requiring root overly complicates things that, strictly speaking, 
shouldn't need to be handled in advance.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

