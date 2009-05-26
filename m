From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Oops on a converted ext4 system
Date: Tue, 26 May 2009 14:28:14 +0200
Message-ID: <4A1BE05E.5040804@wpkg.org>
References: <4A1B8BD0.6050203@wpkg.org> <20090526091404.GA25723@think> <4A1BB4BC.3000301@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	Tomasz Chmielewski <mangoo@wpkg.org>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A1BB4BC.3000301@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski wrote:

>>> Pid: 11454, comm: lzop Not tainted (2.6.30-0.rc7.1mdv #1) MS-6728
>>
>> Does this kernel have any extra patches in it?
> 
> It's a distribution kernel with this description: "NOTE: This kernel has 
> no patches and no third-party drivers".
> So there shouldn't be any extra patches in it.

BTW, mini-904.img.lzo is ~57 GB big; I wanted to uncompress it on the 
same btrfs filesystem with 15 GB left; but it failed immediately.


-- 
Tomasz Chmielewski
http://wpkg.org

