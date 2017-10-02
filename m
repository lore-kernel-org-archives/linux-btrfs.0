Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:44848 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbdJBOQA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 10:16:00 -0400
To: linux-btrfs@vger.kernel.org
Subject: Re: Why do full balance and deduplication reduce available free  space?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 02 Oct 2017 16:15:59 +0200
From: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
In-Reply-To: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
Message-ID: <e7f6ef3185473ba825e8e26499cac55c@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe this is because of the autodefrag mount option? I thought it 
wasn't supposed to unshare lots of extents...

Niccolò
