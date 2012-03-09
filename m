From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1466!
Date: Fri, 09 Mar 2012 09:31:25 +0800
Message-ID: <4F595D6D.6080809@cn.fujitsu.com>
References: <CADDYkjQHvmfhmsdt7K0O74DZK6BVqxPaWh_jEi8uJ_HBEz-QhQ@mail.gmail.com>	<20120308155211.GF4334@twin.jikos.cz> <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: dave@jikos.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, josef@redhat.com
To: Jacek Luczak <difrost.kernel@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CADDYkjTG-q5+pFRFt9sGKq=cgL=ZgQaNZV=2ipBsSbuvxCa3jw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/09/2012 03:35 AM, Jacek Luczak wrote:
> 2012/3/8 David Sterba <dave@jikos.cz>:
>> On Thu, Mar 08, 2012 at 01:10:45PM +0100, Jacek Luczak wrote:
>>> kernel BUG at fs/btrfs/delayed-inode.c:1466!
>> 1461         ret = btrfs_delayed_item_reserve_metadata(trans, root, item);
>> 1462         /*
>> 1463          * we have reserved enough space when we start a new transaction,
>> 1464          * so reserving metadata failure is impossible.
>> 1465          */
>> 1466         BUG_ON(ret);
>>
>>> RAX: 00000000ffffffe4
>> ENOSPC
>>
>>>  [<ffffffffa03210e5>] ? __btrfs_unlink_inode+0x172/0x25e [btrfs]
>>>  [<ffffffffa032158c>] ? btrfs_rename+0x38b/0x55b [btrfs]
>> rename reserves 20 blocks, but seems that's not enough.  I've never seen
>> a crash report in rename, and according to the stacktrace there's
>> nothing suspicious (like selinux related).
> 
> There were quite many things happening in the system at that time.
> Can't really tell what could trigger this.
> 
> Complete logs: http://91.234.146.107/~difrost/logs/tampere_log.gz
> 

Hi Jacek,

So are these warnings based on the latest upstream of btrfs?

thanks,
liubo

> -Jacek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
