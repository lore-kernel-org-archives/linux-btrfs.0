Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36251 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757189AbaISPGB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 11:06:01 -0400
Message-ID: <541C464F.3030600@fb.com>
Date: Fri, 19 Sep 2014 11:05:51 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <rob@robspanton.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Performance Issues
References: <1411129114.1811.7.camel@zarniwoop.blob>
In-Reply-To: <1411129114.1811.7.camel@zarniwoop.blob>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2014 08:18 AM, Rob Spanton wrote:
> Hi,
>
> I have a particularly uncomplicated setup (a desktop PC with a hard
> disk) and I'm seeing particularly slow performance from btrfs.  A `git
> status` in the linux source tree takes about 46 seconds after dropping
> caches, whereas on other machines using ext4 this takes about 13s.  My
> mail client (evolution) also seems to perform particularly poorly on
> this setup, and my hunch is that it's spending a lot of time waiting on
> the filesystem.
>

Weird, I get the exact opposite performance.  Anyway it's probably 
because of your file layouts, try defragging your git dir and see if 
that helps.  Thanks,

Josef
