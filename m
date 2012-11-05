Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57890 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2KEXsE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Nov 2012 18:48:04 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so4298408pad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Nov 2012 15:48:03 -0800 (PST)
Message-ID: <50985030.6020804@gmail.com>
Date: Tue, 06 Nov 2012 07:48:00 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs defrag problem
References: <508FBE50.6070300@gmail.com> <20121031004027.GE3102@twin.jikos.cz> <50919550.3090800@gmail.com> <20121105225716.GO3102@twin.jikos.cz>
In-Reply-To: <20121105225716.GO3102@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/06/2012 06:57 AM, David Sterba wrote:
> On Thu, Nov 01, 2012 at 05:17:04AM +0800, ching wrote:
>>>> 3. Is any possible to online defrag a btrfs partition without hindered by mount point/polyinstantied directories?
>>> Sorry, I do not understand the question.
>> when a device is mounted under a directory, files in the directory is "hidden", and files in the device is "available", right?
>> when a directory is polyinstantied, files in the original directory is "hidden", and files in the polyinstantied directory is "available",
>>
>> How to get past them and pass those "hidden" files to defrag command?
> I hope I get it right, so unless you have a reference to the directory
> with hidden files (using your term), there's no way to access them. And
> this is a more generic question, not related to btrfs itself. The hidden
> files may also belong to a different filesystem.
>
> david
>

thank for your explanation

ching
