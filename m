Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:46728 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBNQNp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 11:13:45 -0500
Received: by mail-ie0-f178.google.com with SMTP id ar20so333539iec.23
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Feb 2014 08:13:45 -0800 (PST)
Message-ID: <52FE40B0.7030101@gmail.com>
Date: Fri, 14 Feb 2014 11:13:36 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Issue with btrfs balance
References: <52F83A69.8080503@gmail.com> <52F8D70B.1090201@swiftspirit.co.za> <52FD90B2.2040004@gmail.com> <52FDCC2F.2070303@swiftspirit.co.za>
In-Reply-To: <52FDCC2F.2070303@swiftspirit.co.za>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/14/2014 02:56 AM, Brendan Hide wrote:
> On 14/02/14 05:42, Austin S. Hemmelgarn wrote:
>>> On 2014/02/10 04:33 AM, Austin S Hemmelgarn wrote:
>> Do you happen to know which git repository and branch is
>> preferred to base patches on?  I'm getting ready to write one to
>> fix this, and would like to make it as easy as possible for the
>> developers to merge.
> A list of the "main" repositories is maintained at 
> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
> 
> I'd suggest David Sterba's branch as he maintains it for
> userspace-tools integration.
> 
In this case, it will need to be patched both in the userspace tools,
and in the kernel, it's the kernel itself that prevents the balance,
cause it thinks that you can't do dup profiles with multiple devices.
