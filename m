From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no
 read/write devices V2
Date: Wed, 30 Nov 2011 15:40:46 +0000
Message-ID: <20111130154046.GG6165@shadowen.org>
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
 <20111128121041.GA19498@elie.hsd1.il.comcast.net>
 <20111128122416.GA25996@localhost>
 <4ED434A9.8020809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jonathan Nieder <jrnieder@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Ivan Vilata i Balaguer <ivan@selidor.net>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ED434A9.8020809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 09:26:01AM +0800, Li Zefan wrote:

> This patch has the same problem with your previous one, that it will set
> f_bavail to 0. I've sent out a new patch yesterday.

Ahh, sounds great thanks.  Often a patch is a good way to start a
discussion to a more correct patch.  Specially when one is not an expert
in the area.

-apw
