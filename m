From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: mount a multi-device filesystem using a loopback device
Date: Wed, 07 Sep 2011 14:44:28 +0800
Message-ID: <4E6712CC.3040404@oracle.com>
References: <4E66F090.4030507@oracle.com> <CAE5mzvjjHh2SZ42o7spb0LQZzsnmf4Dn1hN-JQ-HcFSeZa2dXA@mail.gmail.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAE5mzvjjHh2SZ42o7spb0LQZzsnmf4Dn1hN-JQ-HcFSeZa2dXA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/07/2011 12:37 PM, cwillu wrote:
>> 1.  Create and format two images, the 1st in 400Mbytes, and 2nd in 286Mbytes.
>> root@pibroch:/btrfs-progs# ls -lh /usr/src/linux-3.0/img*
>> -rw-r--r-- 1 jeff jeff 400M 2011-09-07 12:00 /usr/src/linux-3.0/img0
>> -rw-r--r-- 1 jeff jeff 286M 2011-09-07 12:00 /usr/src/linux-3.0/img1
> Very small btrfs filesystem require special handling, mixed block
> groups in particular, which I believe also requires an updated mkfs
> from the integration repo.
Thanks for your response, however, even if I enlarged the image size to 
2G, still got no luck.
Per Zefan's comments, run 'btrfs device scan' fixed this issue.

-Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

