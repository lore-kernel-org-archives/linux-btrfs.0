From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: yum upgrade on btrfs very slow
Date: Thu, 1 Oct 2009 11:04:41 +0200
Message-ID: <20091001090440.GQ14918@kernel.dk>
References: <20090928121827.GA15930@mother.pipebreaker.pl> <20090928133543.GB6405@think> <20090929061822.GB15930@mother.pipebreaker.pl> <20090929132538.GN6405@think> <20090930194350.GA29166@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Tomasz Torcz <tomek@pipebreaker.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090930194350.GA29166@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 30 2009, Tomasz Torcz wrote:
>   I wouldn't expect barriers to work here (reminder, this is PATA drive
> on ICH7 sata controller), but I will test tomorrow with nobarrier.
> Then I probably check his "yum upgrade" under seekwatcher on friday.

Barriers should work fine on that setup. In fact, barriers were first
implemented for PATA back in the day :-)

-- 
Jens Axboe

