From: "Seth Huang" <seth.hg@gmail.com>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 11:17:42 +0800
Message-ID: <200902231117406717229@gmail.com>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>,
 <20090220160134.GE24890@unused.rdu.redhat.com>,
 <1235147425.13249.16.camel@think.oraclecorp.com>,
 <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>,
 <49A18F01.3090300@austin.ibm.com>,
 <3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com>,
 <7fe698080902221722q257819aaj4378dfc1509d3c7d@mail.gmail.com>,
 <3a7f57190902221833i61beb82u38c29dda0eaf5f42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 23, 2009 at 12:22 PM, Dongjun Shin <djshin90@gmail.com> wrote:
> A well-designed SSD should survive power cycling and should provide atomicity
> of flush operation regardless of the underlying flash operations. I don't expect
> that users of SSD have different requirements about atomicity.

A reliable system should be based on the assumption that the underlying parts are unreliable. Therefore, we should do as much as possible to make sure the reliability in our filesystem instead of leaning on the SSDs.

-- 
Seth Huang

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

