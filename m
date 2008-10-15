From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Data-deduplication?
Date: Wed, 15 Oct 2008 17:00:05 +0200
Message-ID: <20081015150005.GU12131@one.firstfloor.org>
References: <20081012020629.GA14615@bludgeon.org> <878wssswqa.fsf@basil.nowhere.org> <48F5F284.1020309@redhat.com> <20081015141543.GT12131@one.firstfloor.org> <f058a9c30810150743p41e285fei5b61a187debe952e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
	Ray Van Dolson <rayvd@bludgeon.org>,
	linux-btrfs@vger.kernel.org
To: Miguel Sousa Filipe <miguel.filipe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30810150743p41e285fei5b61a187debe952e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Like, using bcp (btrfs specific cp) for creating "new" images from a base one?
> Will that suffice?
> With modifications after that being COW, that could be a simple way of
> having a "stupid/hack" no duplication.

qcow already supports that. The challenge is just to deduplicate 
later e.g. when you start applying security updates to the images.

-Andi
