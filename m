Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserver1.prnet.org ([195.46.254.69]:22511 "EHLO
	extserver1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2KWVJU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Nov 2012 16:09:20 -0500
Message-ID: <50AFE5FC.7040304@prnet.org>
Date: Fri, 23 Nov 2012 22:09:16 +0100
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: "Garry T. Williams" <gtwilliams@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: extended attributes wiredness
References: <50AFB620.6040707@prnet.org> <2925363.jTFvA7mLni@vfr>
In-Reply-To: <2925363.jTFvA7mLni@vfr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well, this is only code to demonstrate the problem, the ; is normally a
silly mistake, but for my test case valuelen is < 0 so, the ; doesn't
change anything. With this corrected, the problem stays the same.

On 11/23/12 21:43, Garry T. Williams wrote:
> On Friday, November 23, 2012 18:45:04 David Arendt wrote:
>>   for (i = 0; i < attrslen; i+= strlen(&attrs[i]) + 1)
>>   {
>>     printf("processing attribute %s\n", &attrs[i]);
>>
>>     valuelen = lgetxattr(argv[1], &attrs[i], value, 1024);
>>
>>     if (valuelen < 0);
>   Hmmm ----------------^
>
>
>

