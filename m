From: Jonathan Nieder <jrnieder@gmail.com>
Subject: Re: [PATCH 1/1] btrfs: btrfs_calc_avail_data_space cope with no
 read/write devices V2
Date: Tue, 29 Nov 2011 00:01:35 -0600
Message-ID: <20111129060135.GC31312@elie.hsd1.il.comcast.net>
References: <1312205910-13053-1-git-send-email-apw@canonical.com>
 <20111128121041.GA19498@elie.hsd1.il.comcast.net>
 <20111128122416.GA25996@localhost>
 <4ED434A9.8020809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andy Whitcroft <apw@canonical.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Miao Xie <miaox@cn.fujitsu.com>,
	Ivan Vilata i Balaguer <ivan@selidor.net>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED434A9.8020809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Li Zefan wrote:

> This patch has the same problem with your previous one, that it will set
> f_bavail to 0. I've sent out a new patch yesterday.

Thanks for the quick feedback.  That makes sense.  (The new patch
is at [1], for reference.)

[1] http://thread.gmane.org/gmane.comp.file-systems.btrfs/14584
