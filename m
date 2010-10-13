From: Nikko <nikko.he@oracle.com>
Subject: Re: One question about btrfs
Date: Wed, 13 Oct 2010 10:56:43 +0800
Message-ID: <4CB51FEB.8070006@oracle.com>
References: <4CB2CAE1.2030807@oracle.com> <yq17hhnpclc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <yq17hhnpclc.fsf@sermon.lab.mkp.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/13/10 01:03 AM, Martin K. Petersen wrote:
>>>>>> "Nikko" == Nikko<nikko.he@oracle.com>  writes:
>>>>>>              
> Nikko>  I have a question about btrfs, have you people integrated Oracle
> Nikko>  DIX/T10 DIF into btrfs?
>
> Not yet.  Right now btrfs relies on the block layer to add the integrity
> metadata.
>
>
> Nikko>  If no, do you plan to do that? And what's the reason?
>
> Yes, the reason being that we want applications to be able to pass the
> integrity metadata down from userland.
>
>    
Hi Martin,

Thanks for the guide!

Regards,
Nikko

