Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39401 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaG3WfA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 18:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <20140730205148.GA25256@lenny.home.zabbo.net>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
	<53D959D0.1020303@fb.com>
	<20140730205148.GA25256@lenny.home.zabbo.net>
Date: Wed, 30 Jul 2014 18:34:59 -0400
Message-ID: <CAPDOMVhWmOYNG=WTwXL5V9-t_rAj-eDPB3WQf7Qj4yjcw7v=0Q@mail.gmail.com>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
From: Nick Krause <xerofoify@gmail.com>
To: Zach Brown <zab@zabbo.net>
Cc: Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 30, 2014 at 4:51 PM, Zach Brown <zab@zabbo.net> wrote:
> On Wed, Jul 30, 2014 at 04:47:12PM -0400, Josef Bacik wrote:
>> On 07/30/2014 04:42 PM, Nicholas Krause wrote:
>> >This patch removes the lines for releasing the page cache in certain
>> >files as this may aid in perfomance with writes in the compression
>> >rountines of btrfs. Please note that this patch has not been tested
>> >on my own hardware due to no compression based btrfs volumes of my
>> >own.
>> >
>>
>> http://37.media.tumblr.com/tumblr_m44v95k9Y11qjhgo6o1_250.gif
>
> https://www.youtube.com/watch?v=jVfkYZmXHAg
>
> - z


Zach,
Is there a reason for freeing the page cache as I seem to be missing why?
Regards Nick
