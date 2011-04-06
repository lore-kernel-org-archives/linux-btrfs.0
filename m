From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 2/2 v2] Btrfs: Per file/directory controls for COW and
 compression
Date: Wed, 06 Apr 2011 09:26:21 +0800
Message-ID: <4D9BC13D.3090604@cn.fujitsu.com>
References: <4D8712E9.108@cn.fujitsu.com> <4D999000.1000608@gmail.com> <4D9BC092.1030307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Konstantinos Skarlatos <k.skarlatos@gmail.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D9BC092.1030307@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

liubo wrote:
> On 04/04/2011 05:31 PM, Konstantinos Skarlatos wrote:
>> Hello,
>> I would like to ask about the status of this feature/patch, is it
>> accepted into btrfs code, and how can I use it?
>>
> 
> Yes, it is now in the latest 2.6.39-rc1.
> 
>> I am interested in enabling compression in a specific
>> folder(force-compress would be ideal) of a large btrfs volume, and
>> disabling it for the rest.
>>
> 
> hmm, I'm making the tool's patch, and will come soon. :)
> 

What's wrong with this?

# chattr -c -R /btrfs/folder

(But force-compress is not implemented in the kernel)

