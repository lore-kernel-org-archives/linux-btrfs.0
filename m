Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34230 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199AbcBXSNf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Feb 2016 13:13:35 -0500
Received: by mail-oi0-f41.google.com with SMTP id m82so22276529oif.1
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Feb 2016 10:13:35 -0800 (PST)
Received: from gmail.com (DRMONS0544W-142134058156.dhcp-dynamic.FibreOp.ns.bellaliant.net. [142.134.58.156])
        by smtp.gmail.com with ESMTPSA id 4sm1327984igz.2.2016.02.24.10.13.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 24 Feb 2016 10:13:33 -0800 (PST)
Date: Wed, 24 Feb 2016 14:13:31 -0400
From: Kenny MacDermid <kenny.macdermid@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Input/Output errors
Message-ID: <20160224181329.GB5697@gmail.com>
References: <20160224004045.GA20632@gmail.com>
 <20160224015658.GY22487@merlins.org>
 <20160224030236.GA30797@gmail.com>
 <CAJCQCtQLY-zcz1e8zqNrekEfo1yo9DcDfwR_m4Y8AGaKxV32qg@mail.gmail.com>
 <56CD70A0.30201@dblaci.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <56CD70A0.30201@dblaci.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 24, 2016 at 09:58:08AM +0100, Szalma László wrote:
> - echo 3 > /proc/sys/vm/drop_caches    sometimes fixes the problem, but not
> every time

Interesting. I just had the issue happen with one of my files, tried
this, and it's now readable again.
