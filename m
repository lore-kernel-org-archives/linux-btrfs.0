Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:47668
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932413Ab3CTAwq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 20:52:46 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20130319090653.GQ7229@twin.jikos.cz>
Date: Tue, 19 Mar 2013 18:52:43 -0600
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Message-Id: <560AC1EA-BEF5-4D40-8E7B-19BBF47BB15C@colorremedies.com>
References: <514759B5.5000507@lolwut.org> <20130318191815.15073.49770@localhost.localdomain> <A0DACC7D-01E5-4D36-9526-E871F4E045B6@colorremedies.com> <20130319090653.GQ7229@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 19, 2013, at 3:06 AM, David Sterba <dsterba@suse.cz> wrote:

> On Mon, Mar 18, 2013 at 09:18:28PM -0600, Chris Murphy wrote:
>> I'm not finding a reference to "secure erase trim". In any case I
>> wouldn't expect it to differ from trim.
> 
> There's a 'secure discard' trim command in linux,
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/1007.1/02355.html

"Secure discard is the same as discard except that all copies
of the discarded sectors (perhaps created by garbage collection)
must also be erased."

The erase mechanism seems to be the same "data set management" trim in ACS-2 in either case.


Chris Murphy