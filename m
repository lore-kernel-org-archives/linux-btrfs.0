From: Avi Kivity <avi@redhat.com>
Subject: Re: packing structures and numbers
Date: Sat, 04 Oct 2008 11:27:15 +0300
Message-ID: <48E728E3.3090602@redhat.com>
References: <48E6053A.8010100@redhat.com> <200810031722.52063.phillips@phunq.net> <20081004002856.GA8449@think.oraclecorp.com> <200810031743.46998.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Daniel Phillips <phillips@phunq.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200810031743.46998.phillips@phunq.net>
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Phillips wrote:
> On Friday 03 October 2008 17:28, Chris Mason wrote:
>   
>> On Fri, Oct 03, 2008 at 05:22:51PM -0700, Daniel Phillips wrote:
>>     
>>> ...Are we sure that attribute ((packed)) works the same on all
>>> arches?
>>>       
>> As long as you use types with strictly defined size, yes.
>>     
>
> Just to be a language lawyer about that... int does not have a
> strictly defined size, yet we define uint32_t as a typedef of int
> on 32 bit arches do we not?
>   

What else would you define it to?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

