From: Goffredo Baroncelli <krexxjack@libero.it>
Subject: Re: Create subvolume from a directory?
Date: Wed, 28 Mar 2012 18:54:40 +0200
Message-ID: <4F734250.5030009@libero.it>
References: <loom.20120327T190041-268@post.gmane.org> <20120327222422.GA32675@suse.com> <4F727504.3070105@cn.fujitsu.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: "Matthias G. Eckermann" <mge@suse.com>, Alex <alex@bpmit.com>,
	linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F727504.3070105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>


Hello Liu

On 03/28/2012 04:18 AM, Liu Bo wrote:
> On 03/28/2012 06:24 AM, Matthias G. Eckermann wrote:

>> # time cp -a --reflink /var/lib/lxc/installserver_tmp/rootfs /var/lib/lxc/installserver
>>
>
> This is too much weird.
>
> AFAIK, clone between different subvolumes should be forbidden.
> So this would get a "Invalid cross-device link", because an individual subvolume can be mounted directly.

Could you elaborate which would be the issue ?
"cp --reflink"-ing a file is not different than snapshotting a file. In 
any case I could mount a snapshot and not the source subvolume.



>
> thanks,
> liubo
>
>> real    0m1.367s
>> user    0m0.148s
>> sys     0m1.108s
>>
>> ## Now remove /var/lib/lxc/installserver_tmp (or not)
>>
>> ------------------------------<  snap>------------------------------
>>
>> Just to compare this with a "mv":
>>
>> ------------------------------<  snip>------------------------------
>>
>> ## Go back to former state
>>
>> # btrfs subvol delete /var/lib/lxc/installserver
>> Delete subvolume '/var/lib/lxc/installserver'
>>
>> # btrfs subvol create /var/lib/lxc/installserver
>> Create subvolume '/var/lib/lxc/installserver'
>>
>> # time mv /var/lib/lxc/installserver_tmp/rootfs /var/lib/lxc/installserver/
>>
>> real    0m12.917s
>> user    0m0.208s
>> sys     0m2.508s
>>
>> ------------------------------<  snap>------------------------------
>>
>> While the time measurement might be flawed due to the subvol
>> actions inbetween, caching etc.: I tried several times, and
>> "cp --reflinks" always is multiple times faster than "mv" in
>> my environment.
>>
>> Or did I misunderstand your question?
>>
>> so long -
>> 	MgE
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>

