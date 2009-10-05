From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: yum upgrade on btrfs very slow
Date: Mon, 05 Oct 2009 08:09:05 -0400
Message-ID: <4AC9E1E1.9000001@redhat.com>
References: <20090928121827.GA15930@mother.pipebreaker.pl> <20090928133543.GB6405@think> <20090929061822.GB15930@mother.pipebreaker.pl> <20090929132538.GN6405@think> <20090930194350.GA29166@mother.pipebreaker.pl> <20091001090440.GQ14918@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091001090440.GQ14918@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/01/2009 05:04 AM, Jens Axboe wrote:
> On Wed, Sep 30 2009, Tomasz Torcz wrote:
>    
>>    I wouldn't expect barriers to work here (reminder, this is PATA drive
>> on ICH7 sata controller), but I will test tomorrow with nobarrier.
>> Then I probably check his "yum upgrade" under seekwatcher on friday.
>>      
> Barriers should work fine on that setup. In fact, barriers were first
> implemented for PATA back in the day :-)
>
>    

I think that we first tested them on ich5 & old promise controllers with 
old (250GB) P-ATA disks :-)

ric

