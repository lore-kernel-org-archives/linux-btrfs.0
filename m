Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:54712 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab3KAF0H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Nov 2013 01:26:07 -0400
Message-ID: <52733AA0.1090200@cn.fujitsu.com>
Date: Fri, 01 Nov 2013 13:22:40 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: could not find root 8
References: <20131101142010.02956ad8@virtall.com>
In-Reply-To: <20131101142010.02956ad8@virtall.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

On 11/01/2013 01:20 PM, Tomasz Chmielewski wrote:
> What does this message mean? It started to show up for me recently;
> other than that, the filesystem seems to be working correctly.
Root 8 is  a quota root.

If you disable qgroup, and then run btrfs qgroup show <mnt>
the following message will be outputed.
>
> [58401.456759] could not find root 8
> [58609.749775] could not find root 8
> [58964.522597] could not find root 8
> [59081.202087] could not find root 8
> [59170.927089] could not find root 8
> [61433.903595] could not find root 8
> [61724.565350] could not find root 8
> [61946.555841] could not find root 8
> [62049.610231] could not find root 8
> [62681.216311] could not find root 8
> [62962.234230] could not find root 8
> [64257.237269] could not find root 8
> [65139.473594] could not find root 8
> [65218.750266] could not find root 8
> [67015.850407] could not find root 8
> [67273.966912] could not find root 8
> [67321.037633] could not find root 8
> [68580.801449] could not find root 8
> [68835.545918] could not find root 8
> [69259.784881] could not find root 8
> [70031.465647] could not find root 8
> [71086.657420] could not find root 8
> [71135.165603] could not find root 8
> [72899.558088] could not find root 8
> [73139.577212] could not find root 8
> [73165.132641] could not find root 8
> [73388.199807] could not find root 8
> [73631.840913] could not find root 8
> [74886.201933] could not find root 8
> [75797.512415] could not find root 8
>
>

